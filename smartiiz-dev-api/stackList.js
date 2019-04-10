const fs    = require('fs');
const path  = require('path');
const mysql = require('mysql');
const { promisify } = require("es6-promisify");
const child_process = require('child_process');

const wordpress = (fullPath, projectName) => {
    console.log('HELLO')
    console.log(path.join.apply(null, project_directory, projectName, 'dev'));
    const files = fs.readDirSync(path.join.apply(null, project_directory, projectName, 'dev'));
    if (files && files.length){
        let sqlFiles = files.filter((file) => {return path.extname(file).toLowerCase() === ".sql"});
        const databasename   = "sm_dev_"+projectName.toLowerCase();
        const databaseuser   = "sm_dev_"+projectName.toLowerCase();
        const databasepass   = "smartiiz";
        const cmdCreate      = [
            "CREATE USER '"+databaseuser+"'@'%' IDENTIFIED BY '"+databasepass+"'",
            "CREATE DATABASE '"+databasename+"'",
            "GRANT ALL PRIVILEGES ON mydb.* TO '"+databaseuser+"'@'%' WITH GRANT OPTION;\n"
        ]
        var connection = mysql.createConnection({
            host     : 'localhost',
            user     : 'root',
            password : 'smartiiz',
            port :     '8083'
        });
        const query = promisify(connection.query);
        query('SELECT 1 FROM '+databasename)
            .catch((err) => {
                query(cmdCreate[0])
                    .catch(err => console.log(err))
                    .then((next) => {
                        query(cmdCreate[1])
                            .catch(err => console.log(err))
                            .then((next) => {
                                query(cmdCreate[2])
                                    .catch(err => console.log(err))
                                    .then((next) => {
                                        console.log('Database created');
                                        sqlFiles.forEach((el, inc) => {
                                            child_process.execSync('docker exec -it smartiiz-mysql-5.6 mysql -u'+databaseuser+' -p'+databasepass+' --database='+databasename+' '+path.join.apply(null, project_directory, projectName, 'dev')+'/'+el)
                                            
                                        });
                                        child_process.execSync(`sed "/DB_NAME/s/'[^']*'/'${databasename}'/2  ${path.join.apply(null, project_directory, projectName, 'wp-config.php')}`);
                                        child_process.execSync(`sed "/DB_USER/s/'[^']*'/'${databaseuser}'/2  ${path.join.apply(null, project_directory, projectName, 'wp-config.php')}`);
                                        child_process.execSync(`sed "/DB_PASSWORD/s/'[^']*'/'${databasepass}'/2  ${path.join.apply(null, project_directory, projectName, 'wp-config.php')}`);
                                        child_process.execSync(`sed "/DB_HOST/s/'[^']*'/'localhost:8083'/2  ${path.join.apply(null, project_directory, projectName, 'wp-config.php')}`);
                                    })
                            })
                    })
            }).then((result) => {
                console.log('database already exist');
                child_process.execSync(`sed "/DB_NAME/s/'[^']*'/'${databasename}'/2  ${path.join.apply(null, project_directory, projectName, 'wp-config.php')}`);
                child_process.execSync(`sed "/DB_USER/s/'[^']*'/'${databaseuser}'/2  ${path.join.apply(null, project_directory, projectName, 'wp-config.php')}`);
                child_process.execSync(`sed "/DB_PASSWORD/s/'[^']*'/'${databasepass}'/2  ${path.join.apply(null, project_directory, projectName, 'wp-config.php')}`);
                child_process.execSync(`sed "/DB_HOST/s/'[^']*'/'localhost:8083'/2  ${path.join.apply(null, project_directory, projectName, 'wp-config.php')}`);
            });
    }
}


module.exports = { wordpress };
