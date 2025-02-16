const { EmbedBuilder } = require('discord.js');
const resourcePath = global.GetResourcePath ? global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname;
const settingsjson = require(resourcePath + '/settings.js');

module.exports = {
    name: 'addbaninfo',
    description: 'Add ban information for a user.',
    options: [
        {
            name: 'user_id',
            description: 'Perm ID',
            type: 4,
            required: true,
        },
        {
            name: 'info',
            description: 'Ban Information',
            type: 3,
            required: true,
        },
    ],
    perm: 1,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const fivemexports = client.fivemexports;
        const user_id = interaction.options.getInteger('user_id');
        const info = interaction.options.getString('info');
        const admin = interaction.user;
        fivemexports.corrupt.execute('UPDATE `corrupt_users` SET baninfo = ? WHERE id = ?', [info, user_id]);
        const embed = new EmbedBuilder()
            .setTitle('Added Baninfo')
            .setDescription(`\nPerm ID: **${user_id}**\nBan Info: **${info}**\n\nAdmin: <@${admin.id}>`)
            .setColor(settingsjson.settings.botColour)
            .setTimestamp(new Date());

        await interaction.reply({ embeds: [embed], ephemeral: true });
    },
};
