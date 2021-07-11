#!/usr/bin/env python
# coding: utf8

import os
from flask import Flask

#factory d'application 
def create_app(test_config=None):
    # create and configure the app, __name__ est nom de module Python en cour
    #fichier est relative
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
        DATABASE=os.path.join(app.instance_path, 'flaskr.sqlite'),
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    #route d'aplication
    @app.route('/')
    def hello():
        return "Hello World"
    
    return app