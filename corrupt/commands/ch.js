const { EmbedBuilder } = require('discord.js');
const resourcePath = global.GetResourcePath ? global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname;
const settingsjson = require(resourcePath + '/settings.js');

module.exports = {
    name: 'ch',
    description: 'See how many hours you have.',
    options: [
        {
            name: "user_id",
            description: "User ID",
            type: 4,
            required: false,
        }
    ],
    perm: 0,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const fivemexports = client.fivemexports;
        const author_id = interaction.user.id;
        const user_id = interaction.options.getInteger('user_id');
        if (!user_id) {
            fivemexports.corrupt.execute("SELECT user_id FROM `corrupt_verification` WHERE discord_id = ?", [author_id], (discord) => {
                if (discord.length > 0) {
                    fivemexports.corrupt.execute("SELECT * FROM `corrupt_user_data` WHERE user_id = ?", [discord[0].user_id], (result) => {
                        if (result.length > 0) {
                            const embed = new EmbedBuilder()
                                .setTitle(`You have ${(JSON.parse(result[0].dvalue).PlayerTime/60).toFixed(2)} hours`)
                                .setColor(0x0078ff)
                                .setTimestamp(new Date());
                            interaction.reply({ embeds: [embed], ephemeral: true });
                        } else {
                            const embed = new EmbedBuilder()
                                .setTitle(`Unable to find your hours`)
                                .setColor(0x0078ff)
                                .setTimestamp(new Date());
                            interaction.reply({ embeds: [embed], ephemeral: true });
                        }
                    });
                } else {
                    const embed = new EmbedBuilder()
                        .setTitle("You are not verified")
                        .setColor(0x0078ff)
                        .setTimestamp(new Date());
                    interaction.reply({ embeds: [embed], ephemeral: true });
                }
            });
        } else {
            fivemexports.corrupt.execute("SELECT * FROM `corrupt_user_data` WHERE user_id = ?", [user_id], (result) => {
                if (result.length > 0) {
                    const embed = new EmbedBuilder()
                        .setTitle(`User has ${(JSON.parse(result[0].dvalue).PlayerTime/60).toFixed(2)} hours`)
                        .setColor(0x0078ff)
                        .setTimestamp(new Date());
                    interaction.reply({ embeds: [embed], ephemeral: true });
                } else {
                    const embed = new EmbedBuilder()
                        .setTitle("User has no hours")
                        .setColor(0x0078ff)
                        .setTimestamp(new Date());
                    interaction.reply({ embeds: [embed], ephemeral: true });
                }
            });
        }
    }
};
