const { EmbedBuilder, ButtonBuilder, ModalBuilder, ActionRowBuilder, TextInputBuilder, TextInputStyle } = require('discord.js');

module.exports = {
    name: "support",
    description: "Support Discord",
    perm: 0,
    guild: "1269735017920069634",
    run: async (client, interaction) => {
        const supportdiscord = client.guilds.cache.get('1269735017920069634');
        const invite = await supportdiscord.invites.create('1269735017920069634', { maxAge: 18000, maxUses: 1 });
        const button = new ActionRowBuilder()
            .addComponents(
                new ButtonBuilder()
                    .setLabel('Click Here!')
                    .setStyle(5)
                    .setURL(invite.url)
            )
        const embed = new EmbedBuilder()
        .setTitle("Support Discord")
        .setDescription("Click the button below to join the suport discord.")
        .setColor(0x0078FF)
        .setTimestamp(new Date());
        interaction.reply({ embeds: [embed], components: [button], ephemeral: true });
    }
};