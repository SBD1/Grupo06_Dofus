import postgres from 'postgres'

import Game from './game.js'
import dbConfig from './config/database.js'

const dbInstance = postgres(dbConfig)

new Game()

export default dbInstance
