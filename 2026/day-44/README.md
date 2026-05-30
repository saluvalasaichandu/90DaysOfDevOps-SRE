
## Task 5: Develop and Integrate a Jenkins Shared Library

**Scenario:**  
You are working on multiple pipelines that share common tasks (like code quality checks or deployment steps). To avoid duplication and ensure consistency, you need to develop a Shared Library.

**Steps:**
1. **Create a Shared Library Repository:**  
   - Set up a separate Git repository that hosts your shared library code.
   - Develop reusable functions (e.g., a function for sending notifications or a common test stage).
2. **Integrate the Library:**  
   - Update your Jenkinsfile(s) from previous tasks to load and use the shared library.
   - Use syntax similar to:
     ```groovy
     @Library('my-shared-library') _
     pipeline {
         // pipeline code using shared functions
     }
     ```
3. **Document in `solution.md`:**  
   - Provide code examples from your shared library.
   - Explain how this approach improves maintainability and reduces errors.

**Interview Questions:**
- How do shared libraries contribute to code reuse and maintainability in large organizations?
- Provide an example of a function that would be ideal for a shared library and explain its benefits.

---
