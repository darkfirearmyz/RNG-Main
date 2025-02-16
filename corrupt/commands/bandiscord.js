const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "bandiscord",
    description: "Ban User From Discord",
    options: [
        {
            name: "discord",
            description: "User's Discord",
            type: 6,
            required: true,
        },
        {
            name: "reason",
            description: "Reason for the action",
            type: 3,
            required: false,
        }
    ],
    perm: 10,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
       const user = interaction.options.getUser('discord');
        const reasonofban = interaction.options.getString('reason');
        const member = interaction.guild.members.cache.get(user.id);
        
        if (!member) {
            const embed = new EmbedBuilder()
            .setTitle("Invalid User")
            .setDescription("User not found.")
            .setColor(0xFF0000)
            .setTimestamp(new Date())
            return interaction.reply({ embeds: [embed], ephemeral: true });
        }
        if (member.permissions.has("BAN_MEMBERS")) {
            const embed = new EmbedBuilder()
            .setTitle("Invalid User")
            .setDescription("User is a moderator.")
            .setColor(0xFF0000)
            .setTimestamp(new Date())
            return interaction.reply({ embeds: [embed], ephemeral: true });
        }
        if (!member.bannable) {
            const embed = new EmbedBuilder()
            .setTitle("Invalid User")
            .setDescription("User is not bannable.")
            .setColor(0xFF0000)
            .setTimestamp(new Date())
            return interaction.reply({ embeds: [embed], ephemeral: true });
        }
        const embed = new EmbedBuilder()
        .setTitle("User Banned")
        .setDescription("User <@" + user.id + "> has been banned from the discord.")
        .setColor(0x0078FF)
        .setTimestamp(new Date())
        interaction.reply({ embeds: [embed], ephemeral: true });
        if (reasonofban) {
            member.ban({ reason: reasonofban });
        } else {
            member.ban();
        }
    }
};