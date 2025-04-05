import { describe, it, expect, beforeEach } from "vitest"

// Mock implementation for testing Clarity contracts
const mockTxSender = "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM"
const mockEquipments = new Map()

// Mock contract functions
const registerEquipment = (equipmentId, equipmentType, capabilities, location) => {
  if (mockEquipments.has(equipmentId)) {
    return { type: "err", value: 1 }
  }
  
  mockEquipments.set(equipmentId, {
    owner: mockTxSender,
    equipmentType,
    capabilities,
    location,
    status: "operational",
    lastMaintenance: Date.now(),
    registeredAt: Date.now(),
  })
  
  return { type: "ok", value: true }
}

const updateEquipmentStatus = (equipmentId, newStatus) => {
  if (!mockEquipments.has(equipmentId)) {
    return { type: "err", value: 2 }
  }
  
  const equipment = mockEquipments.get(equipmentId)
  if (equipment.owner !== mockTxSender) {
    return { type: "err", value: 3 }
  }
  
  equipment.status = newStatus
  mockEquipments.set(equipmentId, equipment)
  
  return { type: "ok", value: true }
}

const getEquipment = (equipmentId) => {
  return mockEquipments.get(equipmentId) || null
}

describe("Equipment Registry Contract", () => {
  beforeEach(() => {
    mockEquipments.clear()
  })
  
  it("should register new equipment", () => {
    const result = registerEquipment("equip-123", "satellite-phone", "voice,data,gps", "warehouse-a")
    
    expect(result.type).toBe("ok")
    expect(mockEquipments.has("equip-123")).toBe(true)
    
    const equipment = mockEquipments.get("equip-123")
    expect(equipment.equipmentType).toBe("satellite-phone")
    expect(equipment.status).toBe("operational")
  })
  
  it("should not register equipment with duplicate ID", () => {
    registerEquipment("equip-123", "satellite-phone", "voice,data,gps", "warehouse-a")
    
    const result = registerEquipment("equip-123", "ham-radio", "voice", "warehouse-b")
    
    expect(result.type).toBe("err")
    expect(result.value).toBe(1)
  })
  
  it("should update equipment status", () => {
    registerEquipment("equip-123", "satellite-phone", "voice,data,gps", "warehouse-a")
    
    const result = updateEquipmentStatus("equip-123", "maintenance")
    
    expect(result.type).toBe("ok")
    expect(mockEquipments.get("equip-123").status).toBe("maintenance")
  })
  
  it("should not update status for non-existent equipment", () => {
    const result = updateEquipmentStatus("non-existent", "operational")
    
    expect(result.type).toBe("err")
    expect(result.value).toBe(2)
  })
})

