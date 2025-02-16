const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "removerole",
    description: "Remove Role To User",
    options: [
        {
            name: "discord",
            description: "User's Discord",
            type: 6,
            required: true,
        },
        {
            name: "role",
            description: "Role To Add",
            type: 8,
            required: true,
        }
    ],
    perm: 10,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
       const user = interaction.options.getUser('discord');
        const role = interaction.options.getRole('role');
        const member = interaction.guild.members.cache.get(user.id);
        if (!member) {
            const embed = new EmbedBuilder()
            .setTitle("Invalid User")
            .setDescription("User not found.")
            .setColor(0xFF0000)
            .setTimestamp(new Date())
            return interaction.reply({ embeds: [embed], ephemeral: true });
        }
        if (!role) {
            const embed = new EmbedBuilder()
            .setTitle("Invalid Role")
            .setDescription("Role not found.")
            .setColor(0xFF0000)
            .setTimestamp(new Date())
            return interaction.reply({ embeds: [embed], ephemeral: true });
        }
        if (!member.roles.cache.has(role.id)) {
            const embed = new EmbedBuilder()
            .setTitle("Role Already Removed")
            .setDescription("User does not have this role.")
            .setColor(0xFF0000)
            .setTimestamp(new Date())
            return interaction.reply({ embeds: [embed], ephemeral: true });
        }
        const embed = new EmbedBuilder()
        .setTitle("Role Removed")
        .setDescription("Role **" + role.name + "** has been removed from <@" + user.id + ">")
        .setColor(0x0078FF)
        .setTimestamp(new Date())
        interaction.reply({ embeds: [embed], ephemeral: true });
        member.roles.remove(role);
    }
};