const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

function formatMoney(number, decPlaces, decSep, thouSep) {
    decPlaces = isNaN(decPlaces = Math.abs(decPlaces)) ? 2 : decPlaces;
    decSep = typeof decSep === "undefined" ? "." : decSep;
    thouSep = typeof thouSep === "undefined" ? "," : thouSep;
    const sign = number < 0 ? "-" : "";
    const i = String(parseInt(number = Math.abs(Number(number) || 0).toFixed(decPlaces)));
    let j = i.length > 3 ? i.length % 3 : 0;

    return sign +
        (j ? i.substr(0, j) + thouSep : "") +
        i.substr(j).replace(new RegExp('(\\' + decSep + '{3})(?=\\' + decSep + ')', 'g'), "$1" + thouSep) +
        (decPlaces ? decSep + Math.abs(number - i).toFixed(decPlaces).slice(2) : "");
}


let userConnected = '';
let banned = false;
let discord = 'None';

module.exports = {
    name: "profile",
    description: "Gets Users Profile",
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
        let user_id = interaction.options.getInteger('user_id')

        fivemexports.corrupt.getConnected([parseInt(user_id)], (connected) => {
            userConnected = connected || 'N/A';
        });

        fivemexports.corrupt.execute("SELECT * FROM `corrupt_user_vehicles` WHERE user_id = ?", [user_id], (cars) => {
            fivemexports.corrupt.execute("SELECT * FROM `corrupt_user_data` WHERE user_id = ?", [user_id], (userdata) => {
                fivemexports.corrupt.execute("SELECT * FROM corrupt_warnings WHERE user_id = ?", [user_id], (warnings) => {
                    fivemexports.corrupt.execute("SELECT * FROM corrupt_user_moneys WHERE user_id = ?", [user_id], (money) => {
                        fivemexports.corrupt.execute("SELECT * FROM corrupt_casino_chips WHERE user_id = ?", [user_id], (chips) => {
                            fivemexports.corrupt.execute("SELECT * FROM `corrupt_users` WHERE id = ?", [user_id], (users) => {
                                fivemexports.corrupt.execute("SELECT discord_id FROM `corrupt_verification` WHERE user_id = ?", [user_id], (discordid) => {
                                    fivemexports.corrupt.execute("SELECT gangname FROM `corrupt_user_gangs` WHERE user_id = ?", [user_id], (gangname) => {
                                        fivemexports.corrupt.execute("SELECT * FROM corrupt_offshore WHERE user_id = ?", [user_id], (offshore) => {
                                            const gang = gangname[0]?.gangname || 'None';
                                            discord = discordid[0]?.discord_id ? `<@${discordid[0].discord_id}>` : 'None';
                                            const hours = JSON.stringify(JSON.parse(userdata[0]?.dvalue || '{}').PlayerTime / 60);
                                            const obj = JSON.parse(userdata[0]?.dvalue || '{}').groups;
                                            const lastlogin = users[0]?.last_login?.split(" ") || ['N/A', 'N/A'];
                                            const time = lastlogin[0];
                                            const date = lastlogin[1];

                                            banned = users[0]?.banned === true ? 'Yes' : 'No';
                                            startingmoney = money[0]?.startingcash === true ? 'Yes' : 'No';
                                            const embed = new EmbedBuilder()
                                                .setTitle(`**User Profile**`)
                                                .addFields(
                                                    { name: 'Perm ID:', value: `${user_id}` },
                                                    { name: 'Last Known Username:', value: `${users[0]?.username || 'None'}` },
                                                    { name: 'Associated Discord:', value: discord },
                                                    { name: 'Balance:', value: `Wallet: £${formatMoney(money[0]?.wallet || 0)}\nBank: £${formatMoney(money[0]?.bank || 0)}\nOff Shore: £${formatMoney(offshore[0]?.balance || 0)}\nChips: ${formatMoney(chips[0]?.chips || 0)}\nStarter Money: ${startingmoney}` },
                                                    { name: 'Connected:', value: `User is ${userConnected}.` },
                                                    { name: 'Last Logged In:', value: `${date} at ${time}` },
                                                    { name: 'Hours:', value: `User has a total of ${Math.round(hours)} hours.` },
                                                    { name: 'Gang Name:', value: `${gang}` },
                                                    { name: 'Groups:', value: `${(JSON.stringify(Object.keys(obj)).replace(/"/g, '').replace('[', '').replace(']', '')).replace(/,/g, ', ')}` },
                                                    { name: 'Garage:', value: `User has a total of ${cars.length || '0'} vehicles in their garage.` },
                                                    { name: 'F10:', value: `User has a total of ${warnings.length || '0'} warnings.` },
                                                    { name: 'Banned:', value: `${banned}` }
                                                )
                                                .setTimestamp(new Date())
                                                .setColor(0x0078ff);
                                            interaction.reply({ embeds: [embed], ephemeral: true });
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
            });
        });
    },
};
