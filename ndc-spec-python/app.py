from flask import Flask

app = Flask(__name__)


@app.get("/")
def hello_world():
    return "<p>Hola, World!</p>"


@app.get("/healthz")
def healthz():
    return ("Healthy", 204)


@app.get("/metrics")
def metrics():
    return ("", 200)


@app.get("/capabilities")
def capabilities():
    return """
{
  "versions": "^0.1.0",
  "capabilities": {
    "query": {
      "relation_comparisons": {},
      "order_by_aggregate": {},
      "foreach": {}
    },
    "mutations": {
      "nested_inserts": {},
      "returning": {}
    },
    "relationships": {}
  }
}
    """


@app.get("/schema")
def schema():
    return """
{
  "scalar_types": {
    "Int": {
      "aggregate_functions": {
        "max": {
          "result_type": {
            "type": "nullable",
            "underlying_type": {
              "type": "named",
              "name": "Int"
            }
          }
        },
        "min": {
          "result_type": {
            "type": "nullable",
            "underlying_type": {
              "type": "named",
              "name": "Int"
            }
          }
        }
      },
      "comparison_operators": {},
      "update_operators": {}
    },
    "String": {
      "aggregate_functions": {},
      "comparison_operators": {
        "like": {
          "argument_type": {
            "type": "named",
            "name": "String"
          }
        }
      },
      "update_operators": {}
    }
  },
  "object_types": {
    "article": {
      "description": "An article",
      "fields": {
        "author_id": {
          "description": "The article's author ID",
          "type": {
            "type": "named",
            "name": "Int"
          }
        },
        "id": {
          "description": "The article's primary key",
          "type": {
            "type": "named",
            "name": "Int"
          }
        },
        "title": {
          "description": "The article's title",
          "type": {
            "type": "named",
            "name": "String"
          }
        }
      }
    },
    "author": {
      "description": "An author",
      "fields": {
        "first_name": {
          "description": "The author's first name",
          "type": {
            "type": "named",
            "name": "String"
          }
        },
        "id": {
          "description": "The author's primary key",
          "type": {
            "type": "named",
            "name": "Int"
          }
        },
        "last_name": {
          "description": "The author's last name",
          "type": {
            "type": "named",
            "name": "String"
          }
        }
      }
    }
  },
  "collections": [
    {
      "name": "articles",
      "description": "A collection of articles",
      "arguments": {},
      "type": "article",
      "deletable": false,
      "uniqueness_constraints": {
        "ArticleByID": {
          "unique_columns": [
            "id"
          ]
        }
      },
      "foreign_keys": {}
    },
    {
      "name": "authors",
      "description": "A collection of authors",
      "arguments": {},
      "type": "author",
      "deletable": false,
      "uniqueness_constraints": {
        "AuthorByID": {
          "unique_columns": [
            "id"
          ]
        }
      },
      "foreign_keys": {}
    },
    {
      "name": "articles_by_author",
      "description": "Articles parameterized by author",
      "arguments": {
        "author_id": {
          "type": {
            "type": "named",
            "name": "Int"
          }
        }
      },
      "type": "article",
      "deletable": false,
      "uniqueness_constraints": {},
      "foreign_keys": {}
    }
  ],
  "functions": [
    {
      "name": "latest_article_id",
      "description": "Get the ID of the most recent article",
      "arguments": {},
      "result_type": {
        "type": "nullable",
        "underlying_type": {
          "type": "named",
          "name": "Int"
        }
      }
    }
  ],
  "procedures": [
    {
      "name": "upsert_article",
      "description": "Insert or update an article",
      "arguments": {
        "article": {
          "description": "The article to insert or update",
          "type": {
            "type": "named",
            "name": "article"
          }
        }
      },
      "result_type": {
        "type": "nullable",
        "underlying_type": {
          "type": "named",
          "name": "article"
        }
      }
    }
  ]
}
"""


@app.post("/query")
def query():
    return """
[
  {
    "rows": [
      {
        "ine_": {
          "title": "Row Field Value"
        },
        "elit4": {
          "title": "Row Field Value"
        }
      },
      {
        "est_ae": {
          "title": "Row Field Value"
        },
        "commodo_16b": {
          "title": "Row Field Value"
        }
      }
    ],
    "aggregates": null,
    "dolor__13": "veniam",
    "dolor32": -44004488.342306614
  }
]
    """


@app.post("/explain")
def explain():
    return """
{
  "details": {
    "proident_6": "velit ut in qui",
    "voluptate_42": "sint ipsum cillum ea reprehenderit"
  }
}
    """
