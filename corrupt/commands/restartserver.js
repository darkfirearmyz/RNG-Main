const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "restartserver",
    description: "Restart the server",
    options: [
        {
            name: "time",
            description: "How long to wait before restarting",
            type: 4,
            required: true,
        },
    ],
    perm: 10,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);         
        let amount = interaction.options.getInteger('time')
        let newval = fivemexports.corrupt.corruptbot('RestartServer', [amount])
        const embed = new EmbedBuilder()
        .setTitle("Restarting Server")
        .setDescription(`Time: **${amount}**\n\nAdmin: <@${interaction.user.id}>\n\n`)
        .setColor(0x0078ff)
        .setTimestamp(new Date())
        interaction.reply({ embeds: [embed], ephemeral: true });
    },
};