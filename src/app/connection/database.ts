import postgres from 'postgres'
import dotenv from 'dotenv'
dotenv.config()

const config = {
  host: process.env.HOST,
  port: Number(process.env.PORT),
  database: process.env.DATABASE,
  username: "postgres",
  password: process.env.PASSWORD
}

const dbInstance = postgres(config)

export default dbInstance
