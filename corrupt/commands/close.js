const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "close",
    description: "Close A Car Report",
    options: [
        {
            name: "report_id",
            description: "Car Report ID",
            type: 4,
            required: true,
        },
        {
            name: "notes",
            description: "What Was Changed?",
            type: 3,
            required: true,
        }
    ],
    perm: 4,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);        
        let reportid = interaction.options.getInteger('report_id')
        let notes = interaction.options.getString('notes')
        fivemexports.corrupt.execute("SELECT * FROM cardevs WHERE userid = ?", [interaction.user.id], (user) => {
            if (user[0].currentreport == reportid) {
                fivemexports.corrupt.execute("SELECT * FROM cardev WHERE reportid = ?", [reportid], (result) => {
                    fivemexports.corrupt.execute("UPDATE cardev SET completed = 1, notes = ? WHERE reportid = ?", [notes, reportid]);
                    fivemexports.corrupt.execute("UPDATE cardevs SET reportscompleted = ?, currentreport = ? WHERE userid = ?", [user[0].reportscompleted + 1, 0, interaction.user.id]);
                    const embed = new EmbedBuilder()
                    .setTitle("Car Report")
                    .setDescription(`Car Report **${reportid}** Has Been Closed`)
                    .setColor(0x0078FF)
                    .setTimestamp(new Date())
                    interaction.reply({ embeds: [embed], ephemeral: true });
                    const membed = new EmbedBuilder()
                    .setTitle("Car Report")
                    .setDescription(`Car Report **${reportid}** Has Been Closed\n\nChanges: **${notes}**\n\n*Feel Free To Submit Another Report If Needed*`)
                    .setColor(0x0078FF)
                    .setTimestamp(new Date())
                    client.users.cache.get(result[0].reporter).send({ embeds: [membed] });
                })
            } else {
                const embed = new EmbedBuilder()
                .setTitle("Car Report")
                .setDescription(`You Are Not Assigned To This Report`)
                .setColor(0xFF0000)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });
            }
        })
    },
};