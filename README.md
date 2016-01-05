# rancher-inservice-upgrade-step
[![wercker status](https://app.wercker.com/status/a15e8ae956ffd0a43c6d2fafd1af8208/s/master "wercker status")](https://app.wercker.com/project/bykey/a15e8ae956ffd0a43c6d2fafd1af8208)[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

Wercker step for Rancher In-service upgrades (based on [deploy to rancher](https://app.wercker.com/#applications/562131917b474cd81106a58c/tab/details))

This step does an in-service upgrade for a rancher stack ([documentation](http://docs.rancher.com/rancher/rancher-compose/upgrading/))

You will need to create an API access token and secret for rancher

The rancher URL needs to be your full url including project id. You will get the url on your api key page. Make sure you are using the environment you want to use. Do not include http/s in the url. There is an option for https.

This step has the following prerequisites:
 - curl
 - unzip


**Example:**

    deploy:
      steps:
        - script:
            name: install dependencies for rancher upgrade step
            code: |
              apt-get update
              apt-get install -y curl unzip 
        - nhumrich/deploy-to-rancher:
            access_key: $RANCHER_ACCESS_KEY
            secret_key: $RANCHER_SECRET_KEY
            rancher_url: $RANCHER_URL
            https: false # should https protocol be used?
            tag: latest  # docker tag for the `image:` section in docker-compose
            stack_name: my-awesome-stack  # Rancher stack name
            docker_image: awesome # e.g: nginx or quay.io/<username>/image
            use_tag: false
