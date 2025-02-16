const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "next",
    description: "Get The Next Car Report",
    perm: 3,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
            
        fivemexports.corrupt.execute("SELECT * FROM cardevs WHERE userid = ?", [interaction.user.id], (user) => {
            if (user[0].userid == interaction.user.id) {
                if (!user[0].currentreport == 0) {
                    const embed = new EmbedBuilder()
                    .setTitle("Next Car Report")
                    .setDescription(`Please Complete Or Close Report: **${user[0].currentreport}**\n\n`)
                    .setColor(0x0078FF)
                    .setTimestamp(new Date())
                    interaction.reply({ embeds: [embed], ephemeral: true });
                } else {
                    fivemexports.corrupt.execute("SELECT * FROM cardev WHERE completed = ? AND claimed = ? ORDER BY reportid", [false, false], (report) => {
                        if (report.length > 0) {
                            fivemexports.corrupt.execute("UPDATE cardevs SET currentreport = ? WHERE userid = ?", [report[0].reportid ,interaction.user.id])
                            fivemexports.corrupt.execute("UPDATE cardev SET claimed = ? WHERE reportid = ?", [interaction.user.id,report[0].reportid])
                            const embed = new EmbedBuilder()
                            .setTitle("Next Car Report")
                            .setDescription(`Spawn Code: **${report[0].spawncode}**\n\nIssue: **${report[0].issue}**\n\nReporter: **<@${report[0].reporter}>**\n\nReport ID: **${report[0].reportid}**\n\n*When Completed /close [reportid] [changes]*\n\n`)
                            .setColor(0x0078FF)
                            .setTimestamp(new Date())
                            interaction.reply({ embeds: [embed], ephemeral: true });
                        } else {
                            const embed = new EmbedBuilder()
                            .setTitle("No Reports Available")
                            .setDescription(`Your All Up To Date!`)
                            .setColor(0x0078FF)
                            .setTimestamp(new Date())
                            interaction.reply({ embeds: [embed], ephemeral: true });
                        }
                    })
                }
            } else {
                fivemexports.corrupt.execute("INSERT INTO cardevs (userid, reportscompleted, currentreport) VALUES(?, ?, ?)", [interaction.user.id, 0, 0]);
                fivemexports.corrupt.execute("SELECT * FROM cardev WHERE completed = ? AND claimed = ? ORDER BY reportid", [false, false], (result) => {
                    if (report.length > 0) {
                        fivemexports.corrupt.execute("UPDATE cardevs SET currentreport = ? WHERE userid = ?", [report[0].reportid ,interaction.user.id])
                        fivemexports.corrupt.execute("UPDATE cardev SET claimed = ? WHERE reportid = ?", [interaction.user.id,report[0].reportid])
                        const embed = new EmbedBuilder()
                        .setTitle("Next Car Report")
                        .setDescription(`Spawn Code: **${report[0].spawncode}**\n\nIssue: **${report[0].issue}**\n\nReporter: **<@${report[0].reporter}>**\n\nReport ID: **${report[0].reportid}**\n\n*When Completed /close [reportid] [changes]*\n\n`)
                        .setColor(0x0078FF)
                        .setTimestamp(new Date())
                        interaction.reply({ embeds: [embed], ephemeral: true });
                    } else {
                        const embed = new EmbedBuilder()
                        .setTitle("No Reports Available")
                        .setDescription(`Your All Up To Date!`)
                        .setColor(0x0078FF)
                        .setTimestamp(new Date())
                        interaction.reply({ embeds: [embed], ephemeral: true });
                    }
                })
            }
        })
    },
};