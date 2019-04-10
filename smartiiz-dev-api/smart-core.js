/*
 * Copyright (c) 2019. Smartiiz tous droits réservés. 
 * Author : Brice Daupiard (brice.daupiard@smartiiz.com)
 * Website : https://smartiiz.com
 * Github: https://github.com/SFVII
 */

const fs = require('fs');
const path = require('path');
const child_process = require('child_process');
let   readline = require('readline-sync');
const DOMAIN_EXT = 'smartiiz.lab';
const AVAILABLE_STACK = ['wordpress', 'nodeproject', 'angularproject', 'phpapache2', 'phpnginx'];
let   ENV = process.env;
const current_path = __dirname;
let tmp = current_path.split("/");
delete tmp[tmp.length - 1];
const main_path = tmp.join("/");
const stackList = require('./stackList.js');

const capitalizeFirstLetter = (string) => {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

const createProject = (projectName, stack, repository) => {
    if (!projectName)   throw 'Please give project name';
    if (!stack)         throw 'Missing stack parameters';
    if (!repository)    throw 'Missing github parameters';
    if (AVAILABLE_STACK.indexOf(stack) === -1) {
        throw 'please choose between this available stack '+AVAILABLE_STACK.join(',');
    }
    let home = JSON.parse(fs.readFileSync(ENV.HOME+'/.smartiiz.inc.conf'));
    for (let x in home){
        process.env[x] = home[x]
    }
    createConfiguration()
        .catch(err => console.log(err))
        .then((isValid) => {
            if (!fs.existsSync(process.env['SMARTIIZ_WORK_DIRECTORY']) && !fs.existsSync(process.env['SMARTIIZ_WORK_DIRECTORY']+'/workspace') ) {
                let mkdir = child_process.execSync('mkdir ' + ENV.SMARTIIZ_WORK_DIRECTORY + '/workspace/');
            }
            let github_login    = readline.question('Github login: ');
            let github_password = readline.question('Github password: ');
            let project_directory = [ENV.SMARTIIZ_WORK_DIRECTORY, 'workspace', projectName];
            if (github_login && github_password){
                    if (!fs.existsSync(process.env['SMARTIIZ_WORK_DIRECTORY']+'/workspace/'+projectName)){
                        try {
                            console.log('Creating project path '+path.join.apply(null, project_directory));
                            child_process.execSync('mkdir '+path.join.apply(null, project_directory));
                            child_process.execSync('cd '+path.join.apply(null, project_directory));
                            child_process.execSync('git init '+path.join.apply(null, project_directory));
                            child_process.execSync('git config --global user.name "'+github_login+'" ; git config --global user.password "'+github_password+'"');
                        }catch(err){
                            throw err;
                        }
                    }
                    try {
                        child_process.execSync('git -C '+path.join.apply(null, project_directory)+' pull --force '+repository+ ' ');
                        runProject(stack, path.join.apply(null, project_directory, projectName));
                    }catch(err){
                        throw err;
                    }
               
            } else {
                throw 'Missing github credential';
            }
    });
}
const runProject  = (stack, fullProjectPath, projectName) => { 
    try {
        if (stack === "wordpress") {
            child_process.execSync('sh '+main_path+'smartiiz.sh '+main_path+' clear all;sh '+main_path+'smartiiz.sh '+main_path+' Install '+fullProjectPath+' update')
            console.log('sh '+main_path+'smartiiz.sh '+main_path+' Install '+fullProjectPath+' update')
            console.log('START PROJECT CONFIGURATION', stackList)
            stackList[stack](fullProjectPath, projectName)
                .catch(err => console.log(err))
                .then((job) => {
                    
                });
        }
        
    }catch(err) {
        console.log(err)
    }
}
const destroyProject = () => {

}
const createConfiguration = () => {
    console.log('MOTHER FUCKER')
    return new Promise((resolve, reject) =>{
        console.log('Verification setting');
        let SMARTIIZ_WORK_DIRECTORY = ENV.HOME+'/smartiiz';
        let SMARTIIZ_AVAILABLE_HOST = [];
        try {
            let home = fs.readFileSync(ENV.HOME+'/.smartiiz.inc.conf');
            if (ENV.SMARTIIZ_AVAILABLE_HOST && ENV.SMARTIIZ_WORK_DIRECTORY){
                resolve();
            } else {
                var config = JSON.parse(home);
                for(let key in config){
                    console.log('export '+key+'='+config[key].split(" ").join("@"))
                    child_process.execSync('export $'+key+'='+config[key].split(" ").join("@"));
                }
            }
            resolve();
        }catch (e) {
            console.log('YESSSSS')
            let smartiiz_work_path = readline.question('Default smartiiz work path ( default : '+ENV.HOME+'/smartiiz)');
            if (!smartiiz_work_path) smartiiz_work_path = ENV.HOME+'/smartiiz';
            console.log('SMARTIIZ_WORK_PATH : %s', smartiiz_work_path);
            if (!fs.existsSync(smartiiz_work_path)){
                let mkdir = null;
                try {
                    mkdir = child_process.execSync('mkdir '+smartiiz_work_path);
                    if (!fs.existsSync(smartiiz_work_path)){
                        reject('SMARTIIZ_WORK_PATH ERROR '+smartiiz_work_path);
                    }
                } catch(err) {
                    reject([err, mkdir])
                }
                SMARTIIZ_AVAILABLE_HOST.push(DOMAIN_EXT);
                SMARTIIZ_AVAILABLE_HOST.push('www.'+DOMAIN_EXT);
                const finalConfig = {
                    'SMARTIIZ_WORK_DIRECTORY' : SMARTIIZ_WORK_DIRECTORY,
                    'SMARTIIZ_AVAILABLE_HOST' : '127.0.0.1  '+SMARTIIZ_AVAILABLE_HOST.split(" ").join("@")
                }
                child_process.execSync('export $SMARTIIZ_WORK_DIRECTORY='+SMARTIIZ_WORK_DIRECTORY);
                child_process.execSync('export $SMARTIIZ_AVAILABLE_HOST='+'127.0.0.1  '+SMARTIIZ_AVAILABLE_HOST.split(" ").join("@"));
                const cnf = fs.writeFileSync(ENV.HOME+'/.smartiiz.inc.conf', JSON.stringify(finalConfig));
                if (!cnf){
                    reject(cnf)
                }
                
            }
            resolve();
        }
        
    })
}

module.exports = {createConfiguration, createProject, runProject, destroyProject};
