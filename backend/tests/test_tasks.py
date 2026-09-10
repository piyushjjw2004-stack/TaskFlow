def test_create_task(client, auth_headers):
    payload = {
        "title": "Setup CI/CD Pipeline",
        "description": "Configure GitHub Actions workflow for TaskFlow",
        "status": "in_progress",
        "priority": "high"
    }
    response = client.post("/api/tasks", json=payload, headers=auth_headers)
    assert response.status_code == 201
    data = response.json()
    assert data["title"] == payload["title"]
    assert data["status"] == "in_progress"
    assert data["priority"] == "high"
    assert "id" in data


def test_get_tasks_list_and_filters(client, auth_headers):
    # Create multiple tasks
    client.post("/api/tasks", json={"title": "Task 1", "status": "pending", "priority": "low"}, headers=auth_headers)
    client.post("/api/tasks", json={"title": "Task 2", "status": "completed", "priority": "high"}, headers=auth_headers)

    # Get all
    response = client.get("/api/tasks", headers=auth_headers)
    assert response.status_code == 200
    assert len(response.json()) == 2

    # Filter by status
    response_pending = client.get("/api/tasks?status=pending", headers=auth_headers)
    assert len(response_pending.json()) == 1
    assert response_pending.json()[0]["title"] == "Task 1"

    # Filter by priority
    response_high = client.get("/api/tasks?priority=high", headers=auth_headers)
    assert len(response_high.json()) == 1
    assert response_high.json()[0]["title"] == "Task 2"


def test_get_task_stats(client, auth_headers):
    client.post("/api/tasks", json={"title": "Task 1", "status": "pending", "priority": "low"}, headers=auth_headers)
    client.post("/api/tasks", json={"title": "Task 2", "status": "completed", "priority": "high"}, headers=auth_headers)
    client.post("/api/tasks", json={"title": "Task 3", "status": "in_progress", "priority": "high"}, headers=auth_headers)

    response = client.get("/api/tasks/stats", headers=auth_headers)
    assert response.status_code == 200
    stats = response.json()
    assert stats["total_tasks"] == 3
    assert stats["completed_tasks"] == 1
    assert stats["pending_tasks"] == 1
    assert stats["in_progress_tasks"] == 1
    assert stats["high_priority_tasks"] == 2


def test_update_task(client, auth_headers):
    create_res = client.post("/api/tasks", json={"title": "Task Original"}, headers=auth_headers)
    task_id = create_res.json()["id"]

    update_payload = {"title": "Task Updated", "priority": "high"}
    response = client.put(f"/api/tasks/{task_id}", json=update_payload, headers=auth_headers)
    assert response.status_code == 200
    assert response.json()["title"] == "Task Updated"
    assert response.json()["priority"] == "high"


def test_complete_task_patch(client, auth_headers):
    create_res = client.post("/api/tasks", json={"title": "Incomplete Task", "status": "pending"}, headers=auth_headers)
    task_id = create_res.json()["id"]

    response = client.patch(f"/api/tasks/{task_id}/complete", headers=auth_headers)
    assert response.status_code == 200
    assert response.json()["status"] == "completed"


def test_delete_task(client, auth_headers):
    create_res = client.post("/api/tasks", json={"title": "To be deleted"}, headers=auth_headers)
    task_id = create_res.json()["id"]

    del_res = client.delete(f"/api/tasks/{task_id}", headers=auth_headers)
    assert del_res.status_code == 204

    get_res = client.get(f"/api/tasks/{task_id}", headers=auth_headers)
    assert get_res.status_code == 404


def test_idor_user_cannot_access_or_modify_other_user_task(
    client, auth_headers, second_auth_headers
):
    create_res = client.post(
        "/api/tasks",
        json={"title": "Private Task", "description": "User A data"},
        headers=auth_headers,
    )
    assert create_res.status_code == 201
    task_id = create_res.json()["id"]

    get_res = client.get(f"/api/tasks/{task_id}", headers=second_auth_headers)
    assert get_res.status_code == 404

    put_res = client.put(
        f"/api/tasks/{task_id}",
        json={"title": "Unauthorized Update"},
        headers=second_auth_headers,
    )
    assert put_res.status_code == 404

    patch_res = client.patch(
        f"/api/tasks/{task_id}/complete", headers=second_auth_headers
    )
    assert patch_res.status_code == 404

    delete_res = client.delete(f"/api/tasks/{task_id}", headers=second_auth_headers)
    assert delete_res.status_code == 404

    owner_get = client.get(f"/api/tasks/{task_id}", headers=auth_headers)
    assert owner_get.status_code == 200
    assert owner_get.json()["title"] == "Private Task"
