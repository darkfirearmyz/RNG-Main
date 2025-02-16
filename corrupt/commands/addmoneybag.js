const { ActionRowBuilder, ButtonBuilder, EmbedBuilder, ButtonStyle } = require('discord.js');

function generateUUID(length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charsLength = characters.length;

    let uuid = '';
    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * charsLength);
        uuid += characters.charAt(randomIndex);
    }

    return uuid;
}

module.exports = {
    name: "addmoneybag",
    description: "Add a money bag to a player store.",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        },
        {
            name: "amount",
            description: "Amount",
            type: 3,
            required: true,
            choices: [
                {
                    name: "1 Million",
                    value: "1_money_bag"
                },
                {
                    name: "2 Million",
                    value: "2_money_bag"
                },
                {
                    name: "5 Million",
                    value: "5_money_bag"
                },
                {
                    name: "10 Million",
                    value: "10_money_bag"
                },
                {
                    name: "30 Million",
                    value: "30_money_bag"
                },
                {
                    name: "50 Million",
                    value: "50_money_bag"
                },
                {
                    name: "100 Million",
                    value: "100_money_bag"
                }
            ]
        }
    ],
    perm: 9,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);
        let permid = interaction.options.getInteger('user_id');
        let moneybag = interaction.options.getString('amount');
        const code1 = generateUUID(4);
        const code2 = generateUUID(4);
        const code = (code1 + "-" + code2).toUpperCase();

        const embed = new EmbedBuilder()
            .setTitle("Money Bag Confirmation")
            .setColor("#0078FF")
            .setDescription(`**Perm ID:** ${permid}\n**Amount:** ${moneybag}\n**Code:** ${code}`)
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
                fivemexports.corrupt.execute("INSERT INTO corrupt_stores (code, item, user_id) VALUES (?, ?, ?)", [code, moneybag, permid]);

                const embed = new EmbedBuilder()
                    .setTitle("Money Bag Added")
                    .setColor("#0078FF")
                    .setDescription(`**Perm ID:** ${permid}\n**Amount:** ${moneybag}\n**Code:** ${code}`)
                    .setTimestamp();
                interaction.editReply({ embeds: [embed], components: [] });
            } else {
                collector.stop();
                await i.deferUpdate();
                const embed = new EmbedBuilder()
                    .setTitle("Cancelled")
                    .setColor("#FF0000")
                    .setDescription("Rank addition has been cancelled.")
                    .setTimestamp();
                interaction.editReply({ embeds: [embed], components: [] });
            }
        });
    }
};
