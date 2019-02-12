pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Resolve dependencies') {
      steps {
          sh "pub get"
      }
    }
    stage('Build & Run') {
      steps {
          sh "pub run example/lib/main.dart"
      }
    }
    stage('Run Analyzer') {
      steps {
        sh 'dartanalyzer --options analysis_options.yaml .'
      }
    }
  }
}