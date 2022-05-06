pipeline {
  //  environment {
  //    ID_DOCKER = "choco1992"
      IMAGE_NAME = "django"
      IMAGE_TAG = "latest"  
  //    DOCKERHUB_PASSWORD = credentials('dockerhubpassword')
  //  }could not translate host name "postgres" to address: Name or service not known
  agent none
  stages {
    stage('Build image') {
      agent any
      steps {
        script {
          sh 'docker build -t localhost/$IMAGE_NAME:$IMAGE_TAG .'
        }
      }
    }
    stage('Run container based on builded image') {
      agent any
      steps {
        script {
          sh '''
            docker run --name $IMAGE_NAME -d -p 8000:8000 localhost/$IMAGE_NAME:$IMAGE_TAG
            sleep 5
          '''
        }
      }
    }
    // stage('Test image') {
    //   agent any
    //   steps {
    //     script {
    //       sh ''
    //       '
    //       curl http: //jenkins | grep -i "dimension"
    //         ''
    //       '
    //     }
    //   }
    // }
    // stage('Clean Container') {
    //   agent any
    //   steps {
    //     script {
    //       sh ''
    //       '
    //       docker stop $IMAGE_NAME
    //       docker rm $IMAGE_NAME
    //         ''
    //       '
    //     }
    //   }
    // }
    // stage('Login and Push Image on docker hub') {
    //   agent any
    //   steps {
    //     script {
    //       sh ''
    //       '
    //       echo $DOCKERHUB_PASSWORD | docker login - u $ID_DOCKER--password - stdin
    //       docker push $ {
    //         ID_DOCKER
    //       }
    //       /$IMAGE_NAME:$IMAGE_TAG
    //       ''
    //       '
    //     }
    //   }
    // }
    // stage('Prepare ansible environment') {
    //   agent any
    //   environment {
    //     PRIVATE_KEY = credentials('private_keys_jenkins')
    //   }
    //   steps {
    //     sh ''
    //     '
    //     cp $PRIVATE_KEY id_rsa
    //     chmod 600 id_rsa
    //       ''
    //     '
    //   }
    // }
    // stage('Push image in staging and deploy it') {
    //   agent any
    //   steps {
    //     script {
    //       sh ''
    //       '
    //       cd $WORKSPACE / ansible && ansible - playbook playbooks / deploy_app.yml--private - key.. / id_rsa - e env = staging ''
    //       '
    //     }
    //   }
    // }
    // stage('Push image in production and deploy it') {
    //   when {
    //     expression {
    //       GIT_BRANCH == 'origin/master'
    //     }
    //   }
    //   agent any
    //   steps {
    //     script {
    //       sh ''
    //       '
    //       cd $WORKSPACE / ansible && ansible - playbook playbooks / deploy_app.yml--private - key.. / id_rsa - e env = prod ''
    //       '
    //     }
    //   }
    // }
    // stage('Remove temp files') {
    //   agent any
    //   steps {
    //     sh ''
    //     '
    //     rm - fr $WORKSPACE / ansible / id_rsa ''
    //     '
    //   }
    // }
  }
}