import chalk from 'chalk';
import inquirer from 'inquirer';
import gradient from 'gradient-string';
import chalkAnimation from 'chalk-animation';
import figlet from 'figlet';

import dbInstance from './connection/database.js'
export default class Game {
    constructor() {
        this.run()
    }

    private async run () {
        console.log(dbInstance)
        

        figlet('DOFUS', 'Doom', (_err, data) => {
            console.log(gradient.pastel.multiline(data) + '\n');
          });
    }
}