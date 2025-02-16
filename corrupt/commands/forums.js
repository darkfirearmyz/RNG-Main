const { EmbedBuilder, ButtonBuilder, ModalBuilder, ActionRowBuilder, TextInputBuilder, TextInputStyle } = require('discord.js');

module.exports = {
    name: "forums",
    description: "Corruot Forums",
    perm: 0,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const button = new ActionRowBuilder()
            .addComponents(
                new ButtonBuilder()
                    .setLabel('Click Here!')
                    .setStyle(5)
                    .setURL("https://corruptstudios.net/forums/")
            )
        const embed = new EmbedBuilder()
        .setTitle("Corrupt Forums")
        .setDescription("Click the button below to open forums.")
        .setColor(0x0078FF)
        .setTimestamp(new Date());
        interaction.reply({ embeds: [embed], components: [button], ephemeral: true });
    }
};