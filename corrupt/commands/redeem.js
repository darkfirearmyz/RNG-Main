const { ActionRowBuilder, ButtonBuilder, EmbedBuilder, ButtonStyle } = require('discord.js');

function formatItem(item) {
    return item.split('_').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
}

module.exports = {
    name: "redeem",
    description: "Redeem a store code",
    options: [
        {
            name: "code",
            description: "The code to redeem",
            type: 3,
            required: true,
        }
    ],
    perm: 9,
    guild: "1269735017920069634",
    support: true,
    run: async (client, interaction) => {
        const fivemexports = client.fivemexports;
        const code = interaction.options.getString('code');
        
        fivemexports.corrupt.execute("SELECT * FROM `corrupt_stores` WHERE code = ?", [code], (infoArray) => {
            if (infoArray.length === 0) {
                const embed = new EmbedBuilder()
                    .setTitle("Code Not Found")
                    .setDescription("The provided code was not found or has already been redeemed.")
                    .setColor("#FF0000")
                    .setTimestamp();
                interaction.reply({ embeds: [embed], ephemeral: true });
                return;
            }
    
            const info = infoArray[0];
            const item = formatItem(info.item);
            const user_id = info.user_id;
            const seller_id = info.seller_id;
            const created_at = info.date; 
            const sellerIdValue = seller_id ? seller_id : "N/A";
            const dateMade = created_at ? created_at : "N/A";
    
            fivemexports.corrupt.execute("SELECT discord_id FROM `corrupt_verification` WHERE user_id = ?", [user_id], (discordIdArray) => {
                const discordIdInfo = discordIdArray[0];
                const discord_id = discordIdInfo.discord_id;
    
                const embed = new EmbedBuilder()
                    .setTitle("Redeem Confirmation")
                    .setColor("#0078FF")
                    .setDescription(`**Owner's Discord:** <@${discord_id}>\n**Owner's Perm ID:** ${user_id}\n**Seller ID:** ${sellerIdValue}\n**Item For The Code:** ${item}`)
                    .setFooter({text: "This confirmation will time out in 15 seconds."})
                    .setTimestamp();
    
                const row = new ActionRowBuilder()
                    .addComponents(
                        new ButtonBuilder()
                            .setCustomId('confirm')
                            .setLabel('Confirm')
                            .setStyle(ButtonStyle.Success),
                        new ButtonBuilder()
                            .setCustomId('cancel')
                            .setLabel('Cancel')
                            .setStyle(ButtonStyle.Danger)
                    );
                
                interaction.reply({ embeds: [embed], components: [row], ephemeral: true });

                const filter = i => i.customId === 'confirm' || i.customId === 'cancel';
                const collector = interaction.channel.createMessageComponentCollector({ filter, time: 30000 });
                collector.on('collect', async i => {
                    if (i.customId === 'confirm') {
                        collector.stop();
                        await i.deferUpdate();
                        fivemexports.corrupt.execute("DELETE FROM corrupt_stores WHERE code = ?", [code], (result) => {
                            if (result.affectedRows > 0) {
                                const embed = new EmbedBuilder()
                                    .setTitle("Code Redeemed")
                                    .setDescription(`Code: **${code}**\nItem : **${item}**\nRedeemed by: <@${interaction.user.id}>`)
                                    .setColor("#00FF00")
                                    .setTimestamp();
                                interaction.editReply({ embeds: [embed], components: [] });
                            } else {
                                const embed = new EmbedBuilder()
                                    .setTitle("Code Not Found")
                                    .setDescription("The provided code was not found or has already been redeemed.")
                                    .setColor("#FF0000")
                                    .setTimestamp();
                                interaction.editReply({ embeds: [embed], components: [] });
                            }
                        });
                    } else if (i.customId === 'cancel') {
                        collector.stop();
                        await i.deferUpdate();
                        const embed = new EmbedBuilder()
                            .setTitle("Redeem Canceled")
                            .setDescription(`Redeeming the code: **${code}** was canceled.`)
                            .setColor("#FF0000")
                            .setTimestamp();
                        interaction.editReply({ embeds: [embed], components: [] });
                    }
                });

                collector.on('end', collected => {
                    if (collected.size === 0) {
                        const embed = new EmbedBuilder()
                            .setTitle("Confirmation Timeout")
                            .setDescription(`The confirmation request has timed out. Redeeming the code: **${code}** was canceled.`)
                            .setColor("#FF0000")
                            .setTimestamp();
                        interaction.editReply({ embeds: [embed], components: [] });
                    }
                });
            });
        });
    },
};
