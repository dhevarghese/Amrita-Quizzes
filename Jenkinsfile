pipeline {
    agent any
    stages {
        stage ('Checkout') {
            steps {
                checkout scm
            }
        }
        stage ('Download lcov converter') {
            steps {
                sh "curl -O https://raw.githubusercontent.com/eriwen/lcov-to-cobertura-xml/master/lcov_cobertura/lcov_cobertura.py"
            }
        }
        stage ('Flutter Doctor') {
            steps {
                sh "flutter doctor"
            }
        }
        stage('Test') {
            steps {
                sh "flutter test test/sign_in_page_test.dart"
            }
            post {
                always {
                    sh "sudo apt install python3-distutils -y"
                    sh "python3 lcov_cobertura.py coverage/lcov.info --output coverage/coverage.xml"
                    step([$class: 'CoberturaPublisher', coberturaReportFile: 'coverage/coverage.xml'])
                }
            }
        }
        stage('Run Analyzer') {
            steps {
                sh "dartanalyzer --options analysis_options.yaml ."
            }
        }
    }
}