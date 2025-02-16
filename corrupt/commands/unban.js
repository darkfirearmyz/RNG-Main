const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "unban",
    description: "Unbans A User",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        }
    ],
    perm: 6,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);         
        let user_id = interaction.options.getInteger('user_id')
        let newval = fivemexports.corrupt.corruptbot('setBanned', [user_id, false])
        const embed = new EmbedBuilder()
        .setTitle("Unbaned User")
        .setDescription(`Perm ID: **${user_id}**\n\nAdmin: <@${interaction.user.id}>\n\n`)
        .setColor(0x0078ff)
        .setTimestamp(new Date())
        interaction.reply({ embeds: [embed], ephemeral: true });
    },
};