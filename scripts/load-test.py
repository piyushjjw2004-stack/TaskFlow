#!/usr/bin/env python3
"""
TaskFlow HPA Load Generator Script
Simulates concurrent requests to trigger Kubernetes Horizontal Pod Autoscaler scaling.
"""
import time
import sys
import threading
import urllib.request
import urllib.error

TARGET_URL = sys.argv[1] if len(sys.argv) > 1 else "http://localhost:8000/api/health"
CONCURRENT_THREADS = 20
DURATION_SECONDS = 30

request_count = 0
error_count = 0
stop_flag = False
lock = threading.Lock()


def worker():
    global request_count, error_count
    while not stop_flag:
        try:
            req = urllib.request.Request(TARGET_URL, headers={"User-Agent": "TaskFlow-Load-Test"})
            with urllib.request.urlopen(req, timeout=3) as response:
                if response.status == 200:
                    with lock:
                        request_count += 1
                else:
                    with lock:
                        error_count += 1
        except Exception:
            with lock:
                error_count += 1


def main():
    global stop_flag
    print(f"🚀 Starting load test against {TARGET_URL}")
    print(f"Threads: {CONCURRENT_THREADS} | Duration: {DURATION_SECONDS}s\n")

    threads = []
    start_time = time.time()

    for i in range(CONCURRENT_THREADS):
        t = threading.Thread(target=worker)
        t.daemon = True
        threads.append(t)
        t.start()

    time.sleep(DURATION_SECONDS)
    stop_flag = True

    for t in threads:
        t.join(timeout=1.0)

    total_time = time.time() - start_time
    rps = request_count / total_time if total_time > 0 else 0

    print(f"✅ Load test finished!")
    print(f"Total Requests: {request_count}")
    print(f"Total Errors:   {error_count}")
    print(f"Requests/sec:   {rps:.2f}")


if __name__ == "__main__":
    main()
