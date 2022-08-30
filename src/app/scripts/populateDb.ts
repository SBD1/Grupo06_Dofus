import path from "path";
import { fileURLToPath } from "url";
import dbInstance from "../connection/database.js";

const __filename = fileURLToPath(import.meta.url);

await (async () => {
  try {
    await dbInstance.file(
      `${path.resolve(
        path.dirname(__filename),
        "..",
        "..",
        "src",
        "database",
        "ddl.sql"
      )}`
    );

    await dbInstance.file(
      `${path.resolve(
        path.dirname(__filename),
        "..",
        "..",
        "src",
        "database",
        "stored_procedures.sql"
      )}`
    );

    await dbInstance.file(
      `${path.resolve(
        path.dirname(__filename),
        "..",
        "..",
        "src",
        "database",
        "dml.sql"
      )}`
    );

    console.log("OK");
  } catch (err) {
    console.log(err);
  }
})();

process.exit(0);
