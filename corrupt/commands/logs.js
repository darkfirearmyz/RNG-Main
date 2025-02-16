const { EmbedBuilder, ButtonBuilder, ModalBuilder, ActionRowBuilder, TextInputBuilder, TextInputStyle } = require('discord.js');

module.exports = {
    name: "logs",
    description: "Logs Discord",
    perm: 1,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const logsserver = client.guilds.cache.get('1198602370125410315');
        const invite = await logsserver.invites.create('1198602370968461385', { maxAge: 18000, maxUses: 1 });
        const button = new ActionRowBuilder()
            .addComponents(
                new ButtonBuilder()
                    .setLabel('Click Here!')
                    .setStyle(5)
                    .setURL(invite.url)
            )
        const embed = new EmbedBuilder()
        .setTitle("Logs Discord")
        .setDescription("Click the button below to join the logs discord.")
        .setColor(0x0078FF)
        .setTimestamp(new Date());
        interaction.reply({ embeds: [embed], components: [button], ephemeral: true });
    }
};