[![Built with Cookiecutter](https://img.shields.io/badge/built%20with-Cookiecutter-ff69b4.svg?logo=cookiecutter)](https://github.com/cookiecutter/cookiecutter)

# {{cookiecutter.project_name}} Server


### Setup

#### System Requirements

***brew can be replaced with apt-get for linux***

##### Mac


postgress 
`brew install postgresql` 

pyenv 
`brew instal pyenv`

Pyenv is used to install different version of python to the system should it be neded 

***note there is an issue with certain versions before 3.9 on the new mac chips***

python 3.9
`brew install pipenv`


it is recommended to version the modules for consistency.

celery 
`brew install celery`

or 

`pipenv install celery`

Celery is used to run async tasks 

Redis
`brew install redis`

Redis is used to cache task records the data should be ephemeral

Sentry
Sentry is used for application logging and wil be installed on pipenv install 

### Local Development 


Activate environemnt with 
`pipenv shell`

start the server with (from root)
`python server/manage.py runserver`

run any migrations with (from root)
`python server/manage.py migrate`

Alernatively use the script 
`scripts/init-app.sh`

Run redis normally redis is automatically set to start on startup of the device
`brew services start redis`
`brew services stop redis`

Run celery for any async tasks 
`celery -A starsync worker` - this executes the tasks

`celery -A starsync beat`  - this handles the scheduling of the tasks


### Django App
1. Install Postgres (OSX - `brew install postgresql`; Linux - `apt-get`)
1. Copy .env.example to new file .env 
1. Run `./init-db.sh` from the `scripts` directory (or view and manually create the database)

Once db credentials are set:
1. run `pipenv install` to install dependencies 
1. run `pipenv shell` to activate the pipenv shell
1. run `python manage.py migrate` to migrate database
1. run `python manage.py runserver` to run the Django API (default - localhost:8000/admin)

### Favicon Setup


The Django app is already configured to serve favorite icons for all browsers and platforms (include, for example, apple-icons and android-icons at various sizes). By default, this icon is the vue/react logo.

***Note your image must be a square otherwise a white bg will appear because the file is cropped if it is not a square go to [iloveimg.com](https://www.iloveimg.com/resize-image) and resize it.*** 
Visit [realfavicongenerator.net](https://realfavicongenerator.net/) and upload a high resolution, square version of the image you would like to use as the favicon for this app.

Download the ZIP file of icons that the site generates for you and paste them in the `build/public/static/favicons/` (react) or `client/public/static/favicons/` (vue) directory.

When we run collectstatic the public folder is copied as is and enables serving of the favicons


### Type checks


Running type checks with mypy:

::

  $ mypy starstake

### Test coverage


To run the tests, check your test coverage, and generate an HTML coverage report::

    $ coverage run -m pytest
    $ coverage html
    $ open htmlcov/index.html

Running tests with py.test
~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  $ pytest



