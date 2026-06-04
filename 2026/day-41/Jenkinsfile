pipeline {

    agent any

    stages {

        stage('Checkout') {

            steps {
                echo "Code checkout completed"
            }
        }

        stage('Build') {

            steps {
                echo "Building Application"
            }
        }

        stage('Test') {

            parallel {

                stage('Unit Test') {

                    steps {
                        echo "Running Unit Tests"
                    }
                }

                stage('Code Scan') {

                    steps {
                        echo "Running Code Scan"
                    }
                }
            }
        }

        stage('Deploy') {

            when {
                branch 'main'
            }

            steps {
                echo "Deploying Application"
            }
        }
    }
}
