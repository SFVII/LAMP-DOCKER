/*
 * Copyright (c) 2019. Smartiiz tous droits réservés. 
 * Author : Brice Daupiard (brice.daupiard@smartiiz.com)
 * Website : https://smartiiz.com
 * Github: https://github.com/SFVII
 */

const path      = require('path');
const { exec }  = require('child_process');
const argv      = require('yargs').argv;
const { createProject, runProject, destroyProject, createConfiguration } = require('./smart-core.js');



switch(argv._[0]){
    case 'start':
        createProject(argv.name, argv.template, argv.github);
        break;
        
}

console.log(argv)



