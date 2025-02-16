const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "checkban",
    description: "Check if a player is banned.",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        },
    ],
    perm: 1,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        const fivemexports = interaction.client.fivemexports;
        const level = interaction.client.getPerms(interaction.member);
        const permid = interaction.options.getInteger('user_id');
        const embed = new EmbedBuilder()
            .setTitle(`Checking Ban Status for ${permid}`)
            .setDescription(`<a:loading:1212223312508358706>`)
            .setColor(0x0078ff)
            .setTimestamp(new Date());

        interaction.reply({ embeds: [embed], ephemeral: true });
        // Wait 2 seconds to simulate a loading time
        setTimeout(() => {
            fivemexports.corrupt.execute("SELECT * FROM `corrupt_users` WHERE id = ?", [permid], (result) => {
                if (result.length > 0) {
                    let baninfo = result[0].baninfo
                    if (baninfo == null) {
                        baninfo = "No ban info provided"
                    }
                    var banExpires = new Date(result[0].bantime * 1000)
                    if (banExpires == "Invalid Date") {
                        banExpires = "Never"
                    }
                    banned = result[0]?.banned === true ? 'Yes' : 'No';
                    const embed = new EmbedBuilder()
                        .setTitle(`**Ban Status for ${result[0].username}**`);
                    if (banned == "Yes") {
                        embed.setDescription(`**Perm ID:** ${permid}\n**Banned:** ${banned}\n**Ban Reason:** ${result[0].banreason}\n**Ban Expires:** ${banExpires}\n**Ban Admin:** ${result[0].banadmin}\n**Ban Info:** ${baninfo}`);
                    } else {
                        embed.setDescription(`**Perm ID:** ${permid}\n**Banned:** ${banned}`);
                    }
                    embed.setTimestamp(new Date())
                        .setColor(0x0078ff);
                    interaction.editReply({ embeds: [embed], ephemeral: true });
                }
            })
        }, 2000);
    }
};
