import express from "express";
import initApp from "app";
import config from "config/index";
import database from "database";
import connectAdminJS from "admin";

const globalHTML = `
<h1>FUSEBLE Inc.</h1>
<div>
    <button onclick="goSwagger()">Swagger</button>
    <button style="margin-left: 12px;" onclick="goAdminJS()">AdminJS</button>
</div>
<script>
function handlePath(path){
    window.location.href = window.location.protocol + "//" + window.location.host + path;    
}

function goSwagger(){
    console.log('goSwagger');
    handlePath('/api-docs');
}

function goAdminJS(){
    console.log('goAdminJS');
    handlePath('/adminjs');
}
</script>
`;

(async () => {
  await database.$connect();

  await initApp.init();
  console.log("⭐️ OpenAPI created!");

  connectAdminJS(initApp.app);

  initApp.app.use(express.json({ limit: "50mb" }));
  initApp.app.use(express.urlencoded({ limit: "50mb" }));
  initApp.middlewares([], {});
  initApp.routers({
    globalOptions: {
      html: globalHTML,
      status: 200,
    },
  });

  initApp.app.listen(config.PORT, () => {
    console.log(`🚀 Sever Listening on ${config.PORT}...`);
  });
})();
