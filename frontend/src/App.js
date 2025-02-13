import React, { useState } from "react";
import axios from "axios";
import { TextField, Button, Typography } from "@mui/material";

function App() {
  const [name, setName] = useState("");
  const [greeting, setGreeting] = useState("");

  const handleGreet = async () => {
    try {
      const response = await axios.post("http://localhost:8000/greet", {
        name: name,
      });
      setGreeting(response.data.message);
    } catch (error) {
      console.error("Error:", error);
      setGreeting("Error fetching greeting");
    }
  };

  return (
    <div style={{ padding: 20 }}>
      <TextField
        label="Enter Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />
      <Button variant="contained" color="primary" onClick={handleGreet}>
        Greet
      </Button>
      {greeting && <Typography variant="h5">{greeting}</Typography>}
    </div>
  );
}

export default App;
