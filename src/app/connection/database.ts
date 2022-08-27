import postgres from 'postgres'
import dotenv from 'dotenv'
dotenv.config()

const config = {
  host: process.env.DBHOST,
  port: Number(process.env.DBPORT),
  database: process.env.DBNAME,
  username: process.env.DBUSER,
  password: process.env.DBPASS
}

const dbInstance = postgres(config)

export default dbInstance
