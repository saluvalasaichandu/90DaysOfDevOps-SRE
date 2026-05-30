## Task 1: Create a Jenkins Pipeline Job for CI/CD

**Scenario:**  
Create an end-to-end CI/CD pipeline for a sample application.

**Steps:**
1. **Set Up a Pipeline Job:**  
   - Create a new Pipeline job in Jenkins.
   - Write a basic Jenkinsfile that automates the build, test, and deployment of a sample application (e.g., a simple web app).  
   - Suggested stages: **Build**, **Test**, **Deploy**.
2. **Run and Verify the Pipeline:**  
   - Trigger the pipeline and ensure each stage runs successfully.
   - Verify the execution by checking console logs and, if applicable, using `docker ps` to confirm container status.
3. **Document in `solution.md`:**  
   - Include your Jenkinsfile code and explain the purpose of each stage.
   - Note any issues you encountered and how you resolved them.

**Interview Questions:**
- How do declarative pipelines streamline the CI/CD process compared to scripted pipelines?
- What are the benefits of breaking the pipeline into distinct stages?

---
