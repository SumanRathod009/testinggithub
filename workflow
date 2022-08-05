name: Cloudformation Validator

# This workflow validates all of the cloudformation code

on:
  pull_request:
    paths:
      - 'templates/cloudformation/**/*.yaml'
	    - 'templates/cloudformation/**/*.json'      
	    - 'cloudformation/**/*.yaml'
	    - 'cloudformation/**/*.yml'
	    - 'cloudformation/**/*.json'
    branches:
      - main
  push:   # This is only run when PRs are merged into master
    branches:
      - main

jobs:
  cloudformation-linter:
    name: cfn-lint
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python: [3.8]
    steps:
      - uses: actions/checkout@v2

      - name: Setup Python
        uses: actions/setup-python@v2
        with:
          python-version: ${{ matrix.python }}

      - name: Install cfn-lint
        run: |
          pip install cfn-lint
      - name: Print the CloudFormation linter version and run linter
        run: |
          cd $GITHUB_WORKSPACE
          for fname in $(find ./cloudformation | egrep ".(yaml|yml|json)$"); do ; cfn-lint --template "${fname}" ; done
          for fname in $(find ./templates/cloudformation | egrep ".(yaml|yml|json)$"); do ; cfn-lint --template "${fname}" ; done
          
