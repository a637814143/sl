package com.eightam.lab.web;

import com.eightam.lab.EightamLabApplication;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(classes = EightamLabApplication.class)
@AutoConfigureMockMvc
class DrinkControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void shouldExposeAvailableDrinks() throws Exception {
        mockMvc.perform(get("/api/drinks"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name").exists())
                .andExpect(jsonPath("$[0].price").isNotEmpty());
    }
}
