import postgres from 'postgres'
import dotenv from 'dotenv'
dotenv.config()

const config = {
  host: process.env.HOST,
  port: Number(process.env.PORT),
  database: process.env.DATABASE,
  username: process.env.USERNAME,
  password: process.env.PASSWORD
}

const dbInstance = postgres(config)

console.log('dbInstance')

export default dbInstance
