<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Status Table</title>
    <style>
        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px 0;
            font-size: 16px;
            text-align: left;
        }

        th,
        td {
            border: 1px solid #aaa;
            padding: 8px 12px;
        }

        th {
            background-color: #f2f2f2;
        }

        tr:nth-child(even) {
            background-color: #fafafa;
        }

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
    <h1>Room Status</h1>
    <div id="data" style="color: black; border: 2px solid #007bff; padding: 20px; margin: 20px 0; background-color: #f8f9fa;">
        <h3>Room Data Display Area</h3>
        <div id="loading">Loading room data...</div>
    </div>
    <div id="debug" style="margin-top: 20px; padding: 10px; background-color: #f5f5f5; border: 1px solid #ccc; font-family: monospace; font-size: 12px;">
        <h3>Debug Information:</h3>
        <div id="debug-content">Waiting for API response...</div>
    </div>

    <script>
    function showData() {
        
        const apiUrl = '<%= request.getContextPath() %>/api/room-status';
        console.log('API URL:', apiUrl);
        
        // Update loading message
        document.getElementById('loading').innerHTML = 'Fetching data from API...';
        document.getElementById('debug-content').innerHTML = 'Making API request...';
        
        fetch(apiUrl)
            .then(response => {
                console.log('Response received:', response);
                console.log('Response status:', response.status);
                console.log('Response ok:', response.ok);
                
                // Update debug info
                document.getElementById('debug-content').innerHTML = 
                    `Response Status: ${response.status}<br>
                     Response OK: ${response.ok}<br>
                     Content-Type: ${response.headers.get('content-type')}`;
                
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                
                return response.json();
            })
            .then(result => {
                console.log('JSON response received:', result);
                
                // Update debug with full response
                document.getElementById('debug-content').innerHTML = 
                    `API Response:<br><pre>${JSON.stringify(result, null, 2)}</pre>`;
                
                // Check if API call was successful
                if (!result.success) {
                    throw new Error(`API Error: ${result.message || 'Unknown error'}`);
                }
                
                const data = result.data;
                console.log('Data extracted:', data);
                console.log('Data type:', typeof data);
                console.log('Is array:', Array.isArray(data));
                console.log('Data length:', data ? data.length : 'null/undefined');
                
                // Update loading message
                document.getElementById('loading').innerHTML = 'Processing data...';
                
                if (!data || !Array.isArray(data) || data.length === 0) {
                    document.getElementById('loading').innerHTML = 
                        '<p style="color: #666; font-style: italic;">No room data available.</p>';
                    return;
                }
                
                // Build the table
                console.log('Building table for', data.length, 'rooms');
                let tableHTML = '<table border="1" cellspacing="0" cellpadding="5" style="width: 100%;">';
                tableHTML += '<thead><tr><th>Room ID</th><th>Type</th><th>Base Price</th><th>Room Number</th><th>Status</th></tr></thead>';
                tableHTML += '<tbody>';
                
                data.forEach((room, index) => {
                    console.log(`Processing room ${index}:`, room);
                    const statusClass = room.status ? room.status.toLowerCase() : 'unknown';
                    const basePrice = room.base_price ? room.base_price.toLocaleString() : 'N/A';
                    
                    // Use string concatenation to avoid template literal issues
                    tableHTML += '<tr class="' + statusClass + '">';
                    tableHTML += '<td>' + (room.room_id || 'N/A') + '</td>';
                    tableHTML += '<td>' + (room.type_name || 'N/A') + '</td>';
                    tableHTML += '<td>' + basePrice + '₫</td>';
                    tableHTML += '<td>' + (room.room_number || 'N/A') + '</td>';
                    tableHTML += '<td>' + (room.status || 'Unknown') + '</td>';
                    tableHTML += '</tr>';
                });
                
                tableHTML += '</tbody></table>';
                
                console.log('Table HTML built, updating DOM...');
                
                // Test if element exists
                const loadingElement = document.getElementById('loading');
                console.log('Loading element found:', loadingElement);
                console.log('Loading element current content:', loadingElement ? loadingElement.innerHTML : 'ELEMENT NOT FOUND');
                
                if (!loadingElement) {
                    console.error('ERROR: Element with id="loading" not found!');
                    return;
                }
                
                // Update the display
                loadingElement.innerHTML = tableHTML;
                
                console.log('Loading element updated content:', loadingElement.innerHTML.substring(0, 100) + '...');
                console.log('=== Data display updated successfully ===');
            })
            .catch(error => {
                console.error('Error occurred:', error);
                
                // Update debug with error
                document.getElementById('debug-content').innerHTML = 
                    `Error: ${error.message}<br><pre>${error.stack}</pre>`;
                
                // Show error in main area
                document.getElementById('loading').innerHTML = `
                    <div style="color: #d32f2f; padding: 20px; border: 1px solid #f5c6cb; background-color: #f8d7da; border-radius: 4px;">
                        <h3>Error Loading Data</h3>
                        <p><strong>Error:</strong> ${error.message}</p>
                        <p><strong>Possible solutions:</strong></p>
                        <ul>
                            <li>Make sure you are logged in to the system</li>
                            <li>Check if the server is running</li>
                            <li>Verify the API endpoint is accessible</li>
                        </ul>
                        <p><a href="<%= request.getContextPath() %>/login" style="color: #1976d2;">Go to Login Page</a></p>
                    </div>
                `;
            });
    }

    // Call the function when the page loads
    console.log('Page loaded, starting showData...');
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM Content Loaded event fired');
        showData();
    });
    
    // Also try calling immediately (in case DOMContentLoaded already fired)
    if (document.readyState === 'loading') {
        console.log('Document still loading, waiting for DOMContentLoaded');
    } else {
        console.log('Document already loaded, calling showData immediately');
        showData();
    }
</script>

</body>

</html>