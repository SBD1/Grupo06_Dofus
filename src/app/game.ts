import chalk from "chalk"
import inquirer from "inquirer"
import gradient from "gradient-string"
import chalkAnimation from "chalk-animation"
import figlet from "figlet"

import dbInstance from "./connection/database.js"
import { Choices } from "./util/constants.js"
export default class Game {
  constructor() {
    this.run()
  }

  private async run() {
    figlet("DOFUS", "Doom", async (_err, data) => {
      console.clear()
      console.log(gradient.pastel.multiline(data) + "\n")

      const answer = await inquirer.prompt({
        name: "playOrListAchievements",
        type: "list",
        message: "Selecione uma opção.\n",
        choices: [Choices.PLAY_NOW, Choices.LIST_ACHIEVEMENTS, Choices.QUIT],
      })
      console.log(answer.playOrListAchievements)

      switch (answer) {
        case Choices.PLAY_NOW:
          break
        case Choices.LIST_ACHIEVEMENTS:
          break
        case Choices.QUIT:
          break
        default:
          break
      }
    })
  }
}
