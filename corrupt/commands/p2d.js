const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "p2d",
    description: "Get Player Discord From Perm ID",
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
        let fivemexports = client.fivemexports;     
        let permid = interaction.options.getInteger('user_id')
            
        fivemexports.corrupt.execute("SELECT * FROM `corrupt_verification` WHERE user_id = ?", [permid], (result) => {
            if (result[0].discord_id) {

                const embed = new EmbedBuilder()
                .setTitle("Perm To Discord")
                .setDescription(`\nSuccess! PermID to Discord.\n\n This user is: <@${result[0].discord_id}>\n\n`)
                .setColor(0x0078FF)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });
                
            } else {
                const embed = new EmbedBuilder()
                .setTitle("Perm To Discord")
                .setDescription(`\nFailed! There is no Discord linked to this PermID!\n\n`)
                .setColor(0xFF0000)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });

            }
        }); 
    },
};