### StarStake


Content creators and streamers create tokens that their followers can bid on and redeem for custom prizes.

### Directories

- `client/` contains all of the React files

- `server/` contains all of the Django files

- `.env` file should live at the root directory of the project

- `.env.local` file should live in the `client/` directory

### Local Development 

```
cd client/
yarn install
yarn start
```
``` 
cd server/
python manage.py runserver
# localhost:8000/graphql - graphQL interface
# localhost:8000/admin - Django admin interface
# localhost:3000 - app interface
```

### Deployment

Star Stake is deployed on heroku, heroku is a Platform as a Service (PaaS) that enables developers to build, run and operate applications entirely in the cloud. 
Deployment has been made in such a way to be 90% automated, through GitHub. The automation is carried out with the help of GitHub actions. When a branch (in the form of a PR) is merged into the branch marked as **Develop** GitHub actions will create a one off ubuntu docker container, install the client-side code and its dependencies, install the server-side code and its dependencies and run the marked tests. 

The client app (found in the client folder) is automatically built for production and picks up the appropriate .env variables if available. The build is ultimately moved into the build/ folder. The server will then collect the static files from the server side (admin pages) and client side (build folder) as defined in settings.py and move the files to the designated static folder (or aws if USE_AWS is enabled). This will occur automatically on deployment to heroku the steps are defiend in the root directory package.json. In summary heroku will run: 

- npm install (NPM_CONFIG_PRODUCTION must be set to False to install dev deps in heroku)
- npm run build
- pipenv install 
- pyton manage.py collectstatic --no-input 
- python manage.py migrate ***(set in procfile)**
- python manage.py runserver ***(required to run the gunicorn worker)***




Once the tests have passed the code that is now merged into develop is then deployed to the app marked as **staging** is the heroku pipeline. The develop branch (should be) is protected against direct a push, instead a PR must be made into develop and requires ***one approved review*** in order to be merged. 

Additionally heroku is set up to with a progressive feature called ***review apps***, this helps achieve a more iterative process when developing, testing and approving new features or bugfixes. Review apps are set up in the pipeline settings and are also connected to github. When ***any*** PR is opened into a branch github will deploy a one time version of the app (the name is decided in the settings but is usually pr-XX-appname.herokuapp.com). Once approved and merged the review app is torn down and the merge into develop will trigger the github actions pipeline. For more information regarding review apps and the different configurations please visit [this](https://devcenter.heroku.com/articles/app-json-schema) page. One resource of note is the app.json. This file provides the configuration including any environment variables (that are not secret or not generated on deploy as secret). These override the settings/variables provided for each app (staging/production) and can be found in the pipeline settings apge. If any configuration/setting is not available they will fallback to whatever is currently deployed on production or staging 
As mentioned above deployment is 90% automated reviewing and merging branches is a manual process. When merging to develop a new staging environment is deployed similarly when merging to the main/master branch a new deployment is also triggered onto the app marked as ***production***. 

There are a number of differences between the environments these include the environment variables set and the resources deployed. Some environment variables will vary to enable certain logging levels, others will point to different api keys and others will be turned off altoghether depending on the app's needs. Additionally the resources deployed from one environment to another will be different. For example review apps and staging will most likely use hobby-dev (free tier) as a database tier and free or hobby (free/basic) for their dyno's (currently since we are using review apps and teams hobby is the lowest tier dyno available). This is because we do not expect a large number of operations on the staging application which is used for qa and testing purposes. Additionally in most cases for review apps we may not enable additional resources such as asynchronous job handlers as these apps are designed to be short lived and do not need additional processing power. In a situation where asynchronous tasks may need to run for testing puposes we can do so using a more manual process. Each deployed review app will incur its own additional costs as do staging and prod environments. To read more about the different tiers please visit [this](https://devcenter.heroku.com/articles/dyno-types) page. 

Manual deployments can also be carried out but should be done with caution. When deploying manually you will need to deploy the appropriate branch to master/main. Heroku will only rebuild and deploy code that is pushed to master/main and that is already commited in the repo. A note to be aware of here is that heroku has its own git remotes that should be added to the local environment for deployment, this local remote differs from the git remote used for source control, to add a new heorku remote visit the settings tab in the app in heroku. 

`git push <heroku-remote-name|origin> master` e.g `git push heroku-staging master`

will automatically tirgger heroku to pull the latest commit from the main/master branch from github to its own repository, remember the heroku remote is separate from the git remote and will only trigger a rebuild and deploy when merged into its master. The variable <heroku-remote-name> will differ on each local environment depending on how the developer set up the remote for their local environment. To view remotes use `git remote -v` heroku remotes will have the heroku keyword in their link.
To deploy any other branch other than master you will need to name the branch in the command this is useful when trying to push develop to staging and main/master to prod 

`git push <heroku-remote-name> <branch-name>:master` e.g `git push heroku-prod master`

If adding a new environment variable to an app before deployment be sure to add it to the respective apps: 

- For review apps if the environment variable is not a secret then add it to app.json or directly in the settings tab in heroku
- For staging app add the environment variable in the settings tab 
- For prod app add the enviornment variable in the settings tab


***a Procfile is required to run the server on heroku ***
***a Runtime.txt is required for heroku to run the correct version of python ***

### Settings


During development the client and server have to separate apps for environment variables, these environment variables typically configure the application settings. 

The respective .env* files will live in the subdirectory for the respective build, for access to the .env files for prod/staging reach out by email otherwise copy them over from the heroku settings tab. There is always a template for the server side environment variables found in a .env.example

When adding a new env variable to the dev environment make sure to update the .env.example with the new variable please add doc strings explaining what the variable does, additionally if the app can run without the variable for certain functionality add a **USE_*=True** flag to enable or disable the settings (this is mostly helpful in prod). 



### Scripts

The scripts contained in this folder are primarily used for bootstrapping environments and should rarely be used after initial set up 

- build-docs.sh used to build rst docs (deprecated)
- deployed-on-heroku.sh used to deploy first app to heroku 
- init-app.sh helper to run app used for review apps and locally 
- install-reqs helper to install addtional depenecies if wanted
- init db bootstrapps a new databse 


### Info


This app was bootsrapped using the (thinknimble bootstrapper)[https://github.com/thinknimble/tn-spa-bootstrapper] visit the github page for an updated version and strap some boots!
Files marked as deprecated have been removed and can be safely deleted
