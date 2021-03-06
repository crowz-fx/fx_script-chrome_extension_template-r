# fx_script-chrome_extension_template-r
A templating script which takes in parameters from the user and setups a folder containing the base files required for a Chrome extension project.

## Features
- Templating for folders
- Git init feature with intial commit
- Ability to execute the script interactively taking in the user input

## Notes and considerations
- The output folder is the --ext-name paramter to lowercase and spaces replaced with an _
- The icons are blank files with a .png extension and need to be replaced

## Map of extension and output
```
/{output-location}/{ext-name}/
├── icons
│   ├── icon128.png
│   ├── icon16.png
│   ├── icon256.png
│   ├── icon32.png
│   └── icon48.png
├── manifest.json
├── res
│   └── styles.css
└── src
    ├── index.html
    ├── index.js
    ├── options.html
    └── options.js
```

## Shell execution and parameters
There are 2 ways to execute this script;
1. Script with parameters
2. Script with no parameters and hence run interactively

### Execution
All of the required options and any optional ones you want to specify

#### 1. Script with parameters;
```
./template-r.sh --author="Lui" --name="Template-r" --short="plate-r" --description="Create a template"
```

##### Required parameters
```
# --author="<String>"      ;; default="Joe Bloggs"               ;; name of the author
# --name="<String>"        ;; default="Amazing Extension"        ;; name of the extension
# --short="<String>"       ;; default="Shorty"                   ;; short name of the extension
# --desc="<String>"        ;; default="What a great extension"   ;; no explanation needed
```

##### Optional parameters
```
# --output="<String>"      ;; default=cwd                        ;; where to output the output folder
# --permissions="<String>" ;; default=""                         ;; permissions to give the app i.e. tabs
# --gitinit=true           ;; default=false                      ;; whether to git init and start git source control
# --commitmsg="<String>"   ;; default="Initial commit and setup" ;; message for the intial commit message (have to specified the git-init parameter)
```

#### 2. Run script interactively
```
./template-r.sh
```