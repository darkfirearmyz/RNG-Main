const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "purge",
    description: "Delete Messages",
    options: [
        {
            name: "amount",
            description: "Amount of messages to delete",
            type: 4,
            required: true,
        },
    ],
    perm: 7,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;     
        let amount = interaction.options.getInteger('amount')
        if (amount < 1) return interaction.reply({ content: "You can't delete less than 1 message!", ephemeral: true });
        if (amount > 100) return interaction.reply({ content: "You can't delete more than 100 messages!", ephemeral: true });
        interaction.channel.bulkDelete(amount, true);
        const embed = new EmbedBuilder()
        .setTitle("Purged Messages")
        .setDescription(`\nSuccess! Purged ${amount} messages.\n\n`)
        .setColor(0x0078FF)
        .setTimestamp(new Date())
        interaction.reply({ embeds: [embed], ephemeral: true });
    },
};