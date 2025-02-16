const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "stats",
    description: "Check Car Dev Stats",
    perm: 3,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);        
        fivemexports.corrupt.execute("SELECT * FROM cardevs WHERE userid = ?", [interaction.user.id], (user) => {
            if (user) {
                
                let tickets = user[0].reportscompleted
                let currentreport = user[0].currentreport
                fivemexports.corrupt.execute("SELECT * FROM cardevs ORDER BY reportscompleted", [], (lb) => {
                    for (i = 0; i < lb.length; i++) {
                        if (lb[i].userid == interaction.user.id) {
                            var rank = i + 1
                        }
                    }
                    if (currentreport == 0) {
                        currentreport = "None"
                    }
                    const embed = new EmbedBuilder()
                    .setTitle("Car Dev Stats")
                    .setDescription(`Tickets Completed: **${tickets}**\n\nCurrent Report: **${currentreport}**\n\nRank On Leaderboard: **${rank}**\n\n`)
                    .setColor(0x0078ff)
                    .setTimestamp(new Date())
                    interaction.reply({ embeds: [embed], ephemeral: true });
                });
            }
        })
    },
};