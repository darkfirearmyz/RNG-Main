const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "ip",
    description: "Connect IP To The Server",
    perm: 0,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const embed = new EmbedBuilder()
        .setTitle("Server IP")
        .setDescription("Server IP: **server.corruptstudios.co.uk**")
        .setColor(0x0078FF)
        .setTimestamp(new Date())
        interaction.reply({ embeds: [embed], ephemeral: true });
    }
};