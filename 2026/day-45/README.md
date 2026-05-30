
## Task 6: Integrate Vulnerability Scanning with Trivy

**Scenario:**  
Security is critical in CI/CD. You must ensure that the Docker images built in your pipeline are free from known vulnerabilities.

**Steps:**
1. **Add a Vulnerability Scan Stage:**  
   - Update your Jenkins pipeline to include a stage that runs Trivy on your Docker image:
     ```groovy
     stage('Vulnerability Scan') {
         steps {
             sh 'trivy image <your-username>/sample-app:v1.0'
         }
     }
     ```
2. **Configure Fail Criteria:**  
   - Optionally, set the stage to fail the build if critical vulnerabilities are detected.
3. **Document in `solution.md`:**  
   - Summarize the scan output, note the vulnerabilities and severity, and describe any remediation steps.
   - Reflect on the importance of automated security scanning in CI/CD pipelines.

**Interview Questions:**
- Why is integrating vulnerability scanning into a CI/CD pipeline important?
- How does Trivy help improve the security of your Docker images?

---
