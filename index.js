import config from "config";
import app from "./server/server.js";
import debugLib from "debug";

const debug = debugLib("gseb-ht-gen-backend:index");

const appPort = config.get("App.config.port");

app.listen(appPort, () => {
  debug(`server started on port ${config.port} (${process.env.NODE_ENV})`);
  console.log("PORT FROM CONFIG:", appPort);
});

export default app;
