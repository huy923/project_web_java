<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <link rel="shortcut icon" href="#">
        <style>
            .available {
                background-color: #d4edda;
            }

            .occupied {
                background-color: #f8d7da;
            }

            .maintenance {
                background-color: #fff3cd;
            }
        </style>
    </head>

    <body>
        <div id="showdata"></div>

        <script>
            function showData() {
                const apiUrl = '<%= request.getContextPath() %>/api/room-status';
                fetch(apiUrl)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(result => {
                        const data = result.data;
                        console.log(data[0]);
                        const dataDiv = document.getElementById('showdata');
                        let html = `
                        <table border="1" cellspacing="0" cellpadding="5" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th>Room ID</th>
                                    <th>Type</th>
                                    <th>Base Price</th>
                                    <th>Room Number</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>`;
                        data.forEach(room => {
                            const statusClass = room.status ? room.status.toLowerCase() : 'unknown';
                            const basePrice = room.base_price ? room.base_price.toLocaleString() : 'N/A';
                            html += `<tr class="` + statusClass + `">`;
                            html += `<td>` + room.room_id + `</td>`;
                            html += `<td>` + room.type_name + `</td>`;
                            html += `<td>` + basePrice + `</td>`;
                            html += `<td>` + room.room_number + `</td>`;
                            html += `<td>` + room.status + `</td>`;
                            html += `</tr>`;
                        });
                        html += `</tbody></table>`;
                        dataDiv.innerHTML = html;
                    })
                    .catch(error => {
                        console.error('Error:', error);
                    });
            };
            showData();
        </script>
    </body>

    </html>