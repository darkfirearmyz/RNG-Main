const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "carreport",
    description: "Open a car report",
    options: [
        {
            name: "spawncode",
            description: "Car Spawn Code",
            type: 3,
            required: true,
        },
        {
            name: "issue",
            description: "What needs changing?",
            type: 3,
            required: true,
        }
    ],
    perm: 0,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);        
        let spawncode = interaction.options.getString('spawncode')
        let issue = interaction.options.getString('issue')
        let reporter = interaction.user.id
        let reportid = Math.floor(Math.random() * 100000)
        fivemexports.corrupt.execute("INSERT INTO cardev (spawncode, issue, reporter, claimed,completed,notes) VALUES(?, ?,?, ?, ?,?)", [spawncode, issue, reporter,false, false, ""],(result)  =>  {
            fivemexports.corrupt.execute("SELECT * FROM cardev WHERE reporter = ? AND spawncode = ? AND issue = ?", [interaction.user.id, spawncode, issue], (result) => {
                const embed = new EmbedBuilder()
                .setTitle("Car Report Subbmited")
                .setDescription(`Spawn Code: **${spawncode}**\n\nIssue: **${issue}**\n\nReporter: **<@${interaction.user.id}>**\n\nReport ID: **${result[0].reportid}**\n\n`)
                .setColor(0xFF0000)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });
            });
        });
    },
};