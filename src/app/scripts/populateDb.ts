import postgres from "postgres";
import path from "path";
import dotenv from "dotenv";
import { fileURLToPath } from "url";
dotenv.config();

const config = {
  host: process.env.DBHOST,
  port: Number(process.env.DBPORT),
  database: process.env.DBNAME,
  username: process.env.DBUSER,
  password: process.env.DBPASS,
  max: 1
};

const __filename = fileURLToPath(import.meta.url);
const dbInstance = postgres(config);

(async () => {
  try {
    await dbInstance.file(   `${path.resolve(
      path.dirname(__filename),
      "..",
      "..",
      "src",
      "database",
      "ddl.sql"
    )}`);

    await dbInstance.file(   `${path.resolve(
      path.dirname(__filename),
      "..",
      "..",
      "src",
      "database",
      "dml.sql"
    )}`);
  } catch (err) {
    console.log(err);
  }
})();

process.exit(0)