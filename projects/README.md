# Projects

This folder contains the Python projects created with different package managers.

The projects have the same dependencies installed, which are:

| Name  | Version | Type | 
| ----- | ------- | ---- |
| numpy | Unversioned | Imported and used in the code |
| docopt | Pinned | Remote |
| black | Pinned | Remote from Git |
| seaborn | Pinned | Not used in the code |
| matplotlib | Contrained | Not used in the code |
| urllib3 | Unversioned | Not used in the code |
| nltk | Unversioned | Optional dependency |
| pytest | Unversioned | Development dependency |


The selected combination of front-end and back-end are:

| BE \ FE | Pip | Hatch | Pdm | Pipenv | Poetry |
| --- | --- | --- | --- | --- | --- |
| Hatchling | ✓ | ✓ | ✓ | - | - |
| Flit | - | - | ✓ | - | - |
| Pdm | ✓ | ✓ | ✓ | ✓ | - |
| Poetry | - | - | - | - | ✓ |
| Setuptools | ✓ | ✓ | ✓ | - | - |



## To reproduce it

1) Initialize the project according to the selected front-end.
2) Add the selected dependencies.
3) Add a main file with example code importing an installed
dependency, and using it.
4) Use the package manager to package the project in
a distributable wheel and a source tarball (to test the correctness of the project setup).

### pip
(https://packaging.python.org/en/latest/tutorials/packaging-projects)

Projects are created manually.
* `requirements.txt` contains the core dependencies
* `dev-requirements.txt` contains development dependencies
* `opt-requirements.txt` contains optional dependencies

Note for hatch backend: it requires the following code to be added in the the pyproject.toml

`[tool.hatch.metadata]
allow-direct-references = true`

### hatch
The projects are created by the command:

```hatch new <project-name>```

To build the project (in the projecto folder):

`hatch build`

Dependencies added manually.

Build tool added manually.

Note for hatch backend: it requires the following code to be added in the the pyproject.toml

`[tool.hatch.metadata]
allow-direct-references = true`

### pdm

Create the project:

create a project folder, into the project folder run:

`pdm init`

Add core dependencies:

`pdm add <dependency>`

`pdm add numpy` 

`pdm add black@git+https://github.com/psf/black.git@21.10b0` 

`pdm add "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"` 

`pdm add seaborn==0.12.2`

`pdm add matplotlib>3.9.0` 

`pdm add urllib3` 

Add development and optional dependencies:

`pdm add pytest --dev`

`pdm add -G opt nltk`

Install the dependencies:

`pdm install`

Build the package:

`pdm build`

Note for hatch backend: it requires the following code to be added in the the pyproject.toml

`[tool.hatch.metadata]
allow-direct-references = true`
