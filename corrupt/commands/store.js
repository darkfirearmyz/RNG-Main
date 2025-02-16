const { EmbedBuilder, ButtonBuilder, ModalBuilder, ActionRowBuilder, TextInputBuilder, TextInputStyle } = require('discord.js');

module.exports = {
    name: "store",
    description: "Corruot Store",
    perm: 0,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const button = new ActionRowBuilder()
            .addComponents(
                new ButtonBuilder()
                    .setLabel('Click Here!')
                    .setStyle(5)
                    .setURL("https://corrupt.tebex.io/")
            )
        const embed = new EmbedBuilder()
        .setTitle("Corruot Store")
        .setDescription("Click the button below to open store.")
        .setColor(0x0078FF)
        .setTimestamp(new Date());
        interaction.reply({ embeds: [embed], components: [button], ephemeral: true });
    }
};